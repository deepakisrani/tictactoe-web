var tictactoe = (function() {

    var board, gridBlocks;
    var _waitForComputer = false, gridSize = 0, grid = [], gameid;

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
            _generateGrid();
            gridBlocks = board.querySelectorAll(".js-game-block");
        }
    }

    var _setListeners = function() {
        for (var i = 0; i < gridBlocks.length; i++) {
            gridBlocks[i].addEventListener("click", _gridClick);
        }
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
                    _waitForComputer = false;
                }
                else if (this.readyState === XMLHttpRequest.DONE && this.status !== 200) {
                    curEle.innerHTML = "";
                    _waitForComputer = false;
                }
            }
            xhr.send(JSON.stringify(request));
            
            _waitForComputer = true;
        }
        else if (_waitForComputer) {
            alert("Computer's turn, please wait.");
        }
    }

    var _generatePlaySymbol = function(sym) {
        return "<div class=\"game-element\">" + sym + "</div>";
    }

    var _generateGrid = function() {
        for (var i = 0; i < gridSize; i++) {
            var grid_row = [];
            for (var j = 0; j < gridSize; j++) {
                grid_row.push(0)
            }
            grid.push(grid_row);
        }
    }

    return {
        init: init
    }

})();


window.addEventListener ("load", function() {
    tictactoe.init();
});