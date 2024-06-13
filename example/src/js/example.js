import { TLAppleWallet } from 'tl-apple-wallet-capacitor-plugin';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    TLAppleWallet.echo({ value: inputValue })
}
