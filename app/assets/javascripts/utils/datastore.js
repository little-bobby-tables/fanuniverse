function data(key) {
  const property = document.querySelector('.js-datastore').dataset[key];
  try {
    return JSON.parse(property);
  }
  catch (_) {
    return property;
  }
}

export { data };
