  let defaultsBranch = Services.prefs.getDefaultBranch("betterbird.quicktext.");
  defaultsBranch.setStringPref("code", "no-code");
  let licensePref = Services.prefs.getStringPref("betterbird.quicktext.code", "no-code")
  if (licensePref == "no-code") {
    Services.prompt.alert(
      null,
      "Quicktext Activation",
      "Please enter activation code into preference betterbird.quicktext.code"
    );
    return null;
  }

  let license = licensePref.toUpperCase().replace(/[-=]/g, "").substring(0, 20);
  let licenseOrg = license;
  if (license.length <= 4) {
    Services.prompt.alert(
      null,
      "Quicktext Activation",
      "Please enter activation code into preference betterbird.quicktext.code"
    );
    return null;
  }
  let hasLicense = false;
  let win = Services.wm.getMostRecentWindow("mail:3pane");
  let { MailServices } = ChromeUtils.importESModule("resource:///modules/MailServices.sys.mjs");
  for (let identity of MailServices.accounts.allIdentities) {
    if (!identity.email) continue;
    let email = identity.email.toLowerCase();
    let check = win.btoa(email).toUpperCase().replace(/=/g, "").substring(0, 20);
    let s = 0;
    let c = email.substring(0, 1);
    if (c <= "i") s = 1;
    else if (c <= "r") s = 2;
    else s = 3;
    license = licenseOrg.substring(licenseOrg.length - s) + licenseOrg.substring(0, licenseOrg.length - s);
    if (license == check) {
      hasLicense = true;
      break;
    }
  }
  if (!hasLicense) {
    Services.prompt.alert(
      null,
      "Quicktext Activation",
      "Please enter activation code into preference betterbird.quicktext.code"
    );
    return null;
  }
