ENTITY = {"type": "repository", "default_branch": "main"}

def PASS(res):
    assert.eq(res["status"], "pass")

def FAIL(res):
    assert.true(res["status"] in ("fail", "error"))

def test_should_have_trufflehog_enabled():
    res = eval(
        rule="trufflehog_github_action",
        entity=ENTITY,
        mock_fs={
            ".github/workflows/trufflehog.yaml": read_file("trufflehog_github_action.testdata/github_action_with_trufflehog/.github/workflows/trufflehog.yaml")
        }
    )
    PASS(res)

def test_should_not_have_trufflehog_enabled():
    res = eval(
        rule="trufflehog_github_action",
        entity=ENTITY,
        mock_fs={
            ".github/workflows/not-trufflehog.yaml": read_file("trufflehog_github_action.testdata/github_action_without_trufflehog/.github/workflows/not-trufflehog.yaml")
        }
    )
    FAIL(res)
