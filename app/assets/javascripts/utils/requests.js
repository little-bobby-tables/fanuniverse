function post(endpoint, body) {
  return fetchJson('POST', endpoint, body);
}

function fetchJson(verb, endpoint, body) {
  body._method = verb;

  return fetch(endpoint, {
    method: verb,
    body: JSON.stringify(body),
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': window.Rails.csrfToken(),
    },
  }).then((response) => response.json());
}

export { post };
