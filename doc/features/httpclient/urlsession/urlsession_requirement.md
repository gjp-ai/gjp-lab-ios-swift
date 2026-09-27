# Feature: URLSession

Status: Implemented

## Goal

Let a developer build and send an HTTP request with Apple's native `URLSession` API and inspect the response, as a learning sample for the HTTP Client category.

## Scope

### In scope

- Choose an HTTP method, enter a URL, and optionally enter a JSON payload.
- Send the request and show the status code, response body, and response headers.
- Show a clear, dismissible message when the request cannot be sent or the response cannot be read.

### Out of scope

- Authentication, custom headers, cookies, and request history.
- Third-party HTTP libraries (covered by separate HTTP Client entries such as Alamofire).
- Background or resumable transfers, uploads of files, and streaming.

## Behavior

- The screen opens with `GET` selected and a working sample URL.
- Sending shows a progress indicator and disables the send button until the request finishes.
- A completed request opens a separate response screen, whatever the HTTP status code; 4xx and 5xx responses are shown, not treated as errors.
- A failed request (invalid URL, no network, timeout, unreadable response) stays on the request screen and shows an error message.
- Changing the method clears any visible error.

## UI & Navigation

- Entry point: **HTTP Client** category → **URLSession** catalogue item.
- Request screen controls: method picker (`GET`, `POST`, `PUT`, `DELETE`), URL field, JSON payload field (only for `POST` and `PUT`), and **Send request** button.
- The send button is disabled while a request is running or when the URL is empty.
- Response screen: HTTP status (colored by success or failure and still readable as text), response body (pretty-printed when it is JSON), and headers sorted by name. Body and headers are selectable and scroll horizontally.
- Both screens support light and dark appearance and Dynamic Type, and constrain content width on iPad.

## Rules & Constraints

- Only `http` and `https` URLs are accepted; surrounding whitespace is ignored.
- Requests time out after 15 seconds.
- Requests send `Accept: application/json`; `POST` and `PUT` also send `Content-Type: application/json; charset=utf-8` and include the payload when it is not blank.
- Use only public `URLSession` APIs and Apple transport security defaults; do not add ATS exceptions to make a sample URL work.
- Do not log URLs, payloads, response bodies, or headers; logs may contain only the method, status code, and byte count.

## Platform limitations

- App Transport Security blocks plain `http://` requests to most hosts, so they fail with a system error even though the URL is accepted.
- Response bodies that are not UTF-8 text cannot be displayed.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| URL-AC-01 | Send the default `GET` request with network access | The response screen shows status 200, formatted JSON, and sorted headers. |
| URL-AC-02 | Enter a URL without `http` or `https` and send | An error message asks for a valid http:// or https:// URL; no request is made. |
| URL-AC-03 | Clear the URL field | The send button is disabled. |
| URL-AC-04 | Select `POST` or `PUT` | The payload field appears; it is hidden for `GET` and `DELETE`. |
| URL-AC-05 | The server returns 404 or 500 | The response screen opens and shows the status in the error color. |
| URL-AC-06 | Send with no network, or the server does not answer within 15 seconds | An error message appears on the request screen and can be dismissed. |
| URL-AC-07 | The server returns non-JSON text | The body is shown unchanged. |

## Technical implementation constraints

- Feature folder: `GJPLab/features/httpclient/urlsession/`, with request mechanics in `data/` and value types in `model/`.
- Navigation goes through `FeatureRoute.urlSession` and `FeatureRoute.response`, with destinations in `ContentView`.
- Views do not call `URLSession` directly; `URLSessionRepository` owns request construction, timeouts, formatting, and headers.
- No new dependencies.

## Related documents

- [Detailed design](urlsession_detail_design.md)
- [Application architecture](../../../architecture/application.md)
