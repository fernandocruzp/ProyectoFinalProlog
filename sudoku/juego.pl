% Definición de las matrices a resolver por el usuario.
% '0' representa las casillas vacias que se deben de llenar
% La resolución de los tres sudokus se las mande por el grupo, por si necesitan verificar algo o hacer pruebas.

% Sudoku nivel fácil
tablero(facil, [
    [3, 0, 0, 0, 0, 2, 0, 9, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 4],
    [0, 0, 5, 0, 0, 0, 0, 3, 0],
    [6, 0, 0, 1, 0, 0, 3, 0, 0],
    [0, 0, 0, 0, 6, 0, 0, 0, 8],
    [0, 8, 0, 2, 0, 3, 5, 7, 0],
    [0, 0, 6, 5, 0, 4, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 2],
    [9, 0, 0, 0, 1, 0, 0, 0, 7]
]).

% Sudoku nivel intermedio
tablero(intermedio, [
    [0, 6, 0, 0, 0, 0, 7, 0, 2],
    [0, 0, 0, 0, 0, 8, 0, 0, 1],
    [0, 0, 4, 0, 0, 0, 0, 3, 0],
    [0, 9, 0, 8, 0, 0, 1, 5, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 9],
    [0, 5, 6, 0, 0, 7, 2, 0, 0],
    [7, 0, 0, 2, 0, 0, 0, 0, 0],
    [0, 0, 2, 0, 9, 1, 4, 0, 0],
    [0, 0, 0, 4, 0, 3, 0, 0, 6]
]).

% Sudoku nivel dificil
tablero(dificil, [
    [0, 2, 0, 0, 0, 9, 0, 1, 0],
    [0, 1, 0, 3, 0, 0, 0, 0, 0],
    [0, 4, 0, 6, 0, 0, 0, 9, 2],
    [0, 0, 0, 9, 7, 0, 0, 3, 0],
    [8, 0, 0, 0, 0, 0, 7, 0, 0],
    [0, 0, 0, 5, 0, 0, 0, 0, 4],
    [0, 6, 4, 0, 0, 1, 0, 0, 0],
    [7, 0, 0, 0, 4, 0, 3, 0, 0],
    [5, 0, 0, 2, 0, 0, 0, 0, 0]
]).