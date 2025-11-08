open Bool_vector

let () =
  let module A = Lazy_clear_bool_array in
  let arr = A.create 5 in

  A.set arr 1 true;
  A.set arr 3 true;

  for i = 0 to 4 do
    Printf.printf "%b " (A.get arr i)
  done;
  Printf.printf "\n";

  A.clear arr;

  for i = 0 to 4 do
    Printf.printf "%b " (A.get arr i)
  done;
  Printf.printf "\n";

  A.set arr 2 true;
  A.set arr 4 true;

  for i = 0 to 4 do
    Printf.printf "%b " (A.get arr i)
  done;
  Printf.printf "\n"
