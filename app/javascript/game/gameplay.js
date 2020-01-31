var tictactoe = (function() {

    var board, gridBlocks, overlay;
    var _waitForComputer = false, gridSize = 0, gameid, response;

    var init = function() {
        _setSelectors();
        if (board) {
            _setListeners();
        }
    }

    var _setSelectors = function() {
        board = document.getElementById("js-gamearea");
        if (board) {
            gridSize = board.getAttribute("data-gridsize");
            gameid = board.getAttribute("data-gameid");
            gridBlocks = board.querySelectorAll(".js-game-block");
            overlay = document.querySelector(".overlay");
        }
    }

    var _setListeners = function() {
        for (var i = 0; i < gridBlocks.length; i++) {
            gridBlocks[i].addEventListener("click", _gridClick);
        }
    }

    var _showOverlay = function() {
        overlay.classList.remove("hide");
        overlay.classList.add("show");
    }

    var _hideOverlay = function() {
        overlay.classList.remove("show");
        overlay.classList.add("hide");
    }

    var _gridClick = function(event) {
        var curEle = event.currentTarget;

        if (!curEle.querySelector(".game-element") && !_waitForComputer) {
            curEle.innerHTML = _generatePlaySymbol("X");

            var row = curEle.getAttribute("data-row");
            var column = curEle.getAttribute("data-column");

            var request = {
                "gameid": gameid,
                "gridsize": gridSize,
                "row": row,
                "column": column
            }

            var xhr = new XMLHttpRequest();
            xhr.open("POST", '/api/makemove', true);
            xhr.setRequestHeader("Content-Type", "application/json");

            xhr.onreadystatechange = function() {
                if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
                    console.log(xhr.responseText);

                    response = JSON.parse(xhr.responseText);

                    if (response.continue) {
                        _makeComputerTurn(response.computer_move.row, response.computer_move.col, response.computer_move.symbol);
                        _waitForComputer = false;
                        _hideOverlay();
                    }
                    else {
                        var msg = document.getElementById("message");
                        if (msg) {
                            msg.innerHTML = response.message;
                        }
                        setTimeout(function(){ location.reload(); }, 3000);
                    }
                }
                else if (this.readyState === XMLHttpRequest.DONE && this.status !== 200) {
                    curEle.innerHTML = "";
                    _waitForComputer = false;
                    _hideOverlay();
                }
            }
            xhr.send(JSON.stringify(request));
            
            _waitForComputer = true;
            _showOverlay();
        }
        else if (_waitForComputer) {
            alert("Computer's turn, please wait.");
        }
    }

    var _generatePlaySymbol = function(sym) {
        return "<div class=\"game-element\">" + sym + "</div>";
    }

    var _makeComputerTurn = function(row, col, symbol) {
        ele = document.getElementById("block-" + String(row) + String(col));
        ele.innerHTML = _generatePlaySymbol(symbol);
    }

    var getR = function() {
        return response;
    }

    return {
        init: init,
        get: getR
    }

})();

console.log("loaded")
window.addEventListener ("load", function(event) {
    console.log("inside load event")
    tictactoe.init();
});