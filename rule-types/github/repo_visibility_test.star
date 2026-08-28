ENTITY = {"owner": "coolhead", "name": "haze-wave", "type": "repository", "default_branch": "main"}
URL = "/repos/coolhead/haze-wave"

def PASS(res):
    assert.eq(res["status"], "pass")

def FAIL(res):
    assert.true(res["status"] in ("fail", "error"))

def test_should_be_public():
    res = eval(
        rule="repo_visibility",
        entity=ENTITY,
        profile={"visibility": "public"},
        mock_http={
            URL: body(read_file("repo_visibility.testdata/public.json"))
        }
    )
    PASS(res)

def test_should_be_private():
    res = eval(
        rule="repo_visibility",
        entity=ENTITY,
        profile={"visibility": "private"},
        mock_http={
            URL: body(read_file("repo_visibility.testdata/private.json"))
        }
    )
    PASS(res)

def test_should_be_public_but_is_private():
    res = eval(
        rule="repo_visibility",
        entity=ENTITY,
        profile={"visibility": "public"},
        mock_http={
            URL: body(read_file("repo_visibility.testdata/private.json"))
        }
    )
    FAIL(res)

def test_not_found_should_fail():
    res = eval(
        rule="repo_visibility",
        entity=ENTITY,
        profile={"visibility": "public"},
        mock_http={
            URL: body(read_file("repo_visibility.testdata/notfound.json")).code(404)
        }
    )
    FAIL(res)

def test_internal_server_error_should_fail():
    res = eval(
        rule="repo_visibility",
        entity=ENTITY,
        profile={},
        mock_http={
            URL: body("").code(500)
        }
    )
    FAIL(res)
