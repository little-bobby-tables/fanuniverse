const redirectSignedOutTo = '/users/sign_up';

export function signedIn(e) {
  e && e.preventDefault();

  const signedIn = !!document.querySelector('.js-signed-in');

  if (signedIn) return true;
  else window.location.href = redirectSignedOutTo;
}
