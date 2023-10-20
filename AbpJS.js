function Msg() {
    if (localStorage.getItem("email") !== null) {
        alert(localStorage.getItem("email"));
    }
    else {
        alert('Email not found');
    }
}

function Test() {
        alert('hello');
}