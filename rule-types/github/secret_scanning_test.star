ENTITY = {"owner": "coolhead", "name": "haze-wave", "type": "repository", "default_branch": "main"}
URL = "/repos/coolhead/haze-wave"

def PASS(res):
    assert.eq(res["status"], "pass")

def FAIL(res):
    assert.true(res["status"] in ("fail", "error"))

def test_should_have_secret_scanning_enabled():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={},
        mock_http={
            URL: body(read_file("secret_scanning.testdata/enabled.json"))
        }
    )
    PASS(res)

def test_should_have_secret_scanning_enabled_for_private_repo():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={"skip_private_repos": False},
        mock_http={
            URL: body(read_file("secret_scanning.testdata/private-enabled.json"))
        }
    )
    PASS(res)

def test_private_repo_should_skip():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={"skip_private_repos": True},
        mock_http={
            URL: body(read_file("secret_scanning.testdata/private-enabled.json"))
        }
    )
    assert.eq(res["status"], "skip")

def test_disabled_secret_scanning_denied():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={},
        mock_http={
            URL: body(read_file("secret_scanning.testdata/disabled.json"))
        }
    )
    FAIL(res)
    assert.true(res["message"] != "")

def test_not_found_should_fail():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={},
        mock_http={
            URL: body(read_file("secret_scanning.testdata/notfound.json")).code(404)
        }
    )
    FAIL(res)
    assert.true(res["message"] != "")

def test_internal_server_error_should_fail():
    res = eval(
        rule="secret_scanning",
        entity=ENTITY,
        profile={},
        mock_http={
            URL: body("").code(500)
        }
    )
    FAIL(res)
    assert.true(res["message"] != "")
