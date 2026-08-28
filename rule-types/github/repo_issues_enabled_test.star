ENTITY = {"owner": "coolhead", "name": "haze-wave", "type": "repository", "default_branch": "main"}
URL = "/repos/coolhead/haze-wave"

def PASS(res):
    assert.eq(res["status"], "pass")

def FAIL(res):
    assert.true(res["status"] in ("fail", "error"))

def repo_issues(has_issues):
    """Helper to build eval result for repo_issues_enabled rule."""
    return eval(
        rule="repo_issues_enabled",
        entity=ENTITY,
        mock_http={
            URL: body('{"has_issues": %s}' % ("true" if has_issues else "false"))
        }
    )

def test_issues_are_enabled():
    PASS(repo_issues(True))

def test_issues_should_be_enabled():
    FAIL(repo_issues(False))

def test_not_found_should_fail():
    res = eval(
        rule="repo_issues_enabled",
        entity=ENTITY,
        mock_http={
            URL: body("").code(404)
        }
    )
    FAIL(res)

def test_internal_server_error_should_fail():
    res = eval(
        rule="repo_issues_enabled",
        entity=ENTITY,
        mock_http={
            URL: body("").code(500)
        }
    )
    FAIL(res)
