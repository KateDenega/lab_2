% Copyright

implement main
    open core, stdio, file

domains
    genre = документальный_фильм; драма; мелодрама; комедия; ужасы.

class facts - kino
    кинотеатр : (integer Id_кин, string Наз_кин, string Адрес, string Телефон, integer Колво_мест).
    кинофильм : (integer Id_фил, string Наз_фил, integer Год, string Режиссёр, genre Жанр).
    показывают : (integer Id_кин, integer Id_фил, string Дата, integer Стоим_бил).

class facts
    s : (real Sum) single.

clauses
    s(0).

class predicates
    длина : (A*) -> integer N.
    сумма_элем : (real* List) -> real Sum.
    среднее_списка : (real* List) -> real Average determ.

clauses
    длина([]) = 0.
    длина([_ | T]) = длина(T) + 1.

    сумма_элем([]) = 0.
    сумма_элем([H | T]) = сумма_элем(T) + H.

    среднее_списка(L) = сумма_элем(L) / длина(L) :-
        длина(L) > 0.

class predicates
    кинотеатр_опред_фильм : (string Наз_фил) -> string* Компоненты determ.
    адрес_кин_жанр : (genre Жанр) nondeterm.
    адрес_кин_реж : (string Режис) nondeterm.
    прибыль_театра_за_фильм : (string Наз_фил) nondeterm.

clauses
% кинотеатр, показыввающий опред. фильм
    кинотеатр_опред_фильм(Film) = List :-
        кинофильм(ID_filma, Film, _, _, _),
        !,
        List =
            [ Name_kinotr ||
                показывают(ID_kinotr, ID_filma, _, _),
                кинотеатр(ID_kinotr, Name_kinotr, _, _, _)
            ].

% адрес кинотеатра, показывающего фильм опред. жанра
    адрес_кин_жанр(Genre) :-
        показывают(ID_kinotr, ID_filma_, _, _),
        кинофильм(ID_filma_, _, _, _, Genre),
        кинотеатр(ID_kinotr, Name_kinotr, Adres_kin, _, _),
        write("По этому адресу: ", Adres_kin, ", кинотеатр ", Name_kinotr, ", показывает фильм этого жанра: ", Genre, "\n"),
        nl,
        fail.
    адрес_кин_жанр(Genre) :-
        кинофильм(ID_filma_, _, _, _, Genre),
        nl.
% адрес кинотеатра, показывающего фильм опред. режиссёра
    адрес_кин_реж(Rejis) :-
        кинофильм(ID_filma_, Film, _, Rejis, _),
        показывают(ID_kinotr, ID_filma_, _, _),
        кинотеатр(ID_kinotr, _, Adres_kin, _, _),
        write("По этому адресу: ", Adres_kin, " показывают фильм: ", Film, ", режиссёра: ", Rejis),
        nl,
        fail.
    адрес_кин_реж(Rejis) :-
        кинофильм(_, _, _, Rejis, _),
        nl.

% прибыль театра за фильм
    прибыль_театра_за_фильм(Film) :-
        кинофильм(ID_filma, Film, _, _, _),
        кинотеатр(ID_kinotr, _, _, _, Kolvo_mest),
        показывают(ID_kinotr, ID_filma, _, Stoim_bileta),
        s(Sum),
        assert(s(Sum + Stoim_bileta * Kolvo_mest)),
        fail.
    прибыль_театра_за_фильм(Film) :-
        кинофильм(_, Film, _, _, _),
        s(Sum),
        write("Прибыль театра: ", Sum, "\n"),
        nl.
%---------------------------------------------------------------
    run() :-
        console::init(),
        reconsult("...\\konsult.txt", kino),
        write("Kинотеатр, показыввающий опред. фильм\n"),
        write(кинотеатр_опред_фильм("Улитки в законе"), "ЧТО-ТО\n"),
        fail.

    run() :-
        console::init(),
        reconsult("...\\konsult.txt", kino),
        write("Адрес кинотеатра, показывающего фильм опред. жанра\n"),
        адрес_кин_жанр(драма),
        fail.

    run() :-
        console::init(),
        reconsult("...\\konsult.txt", kino),
        write("Aдрес кинотеатра, показывающего фильм опред. режиссёра\n"),
        адрес_кин_реж("Джуниор В."),
        fail.

    run() :-
        console::init(),
        reconsult("...\\konsult.txt", kino),
        write("Прибыль театра за фильм\n"),
        прибыль_театра_за_фильм("Портной"),
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
