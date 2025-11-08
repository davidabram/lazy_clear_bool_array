type t = {
  n : int;
  values : bool array;
  ts : int array;
  mutable cur : int;
  mutable fv : int;
}

let length a = a.n

let create n =
  if n < 0 then invalid_arg "Lazy_clear_bool_array.create: negative length";
  { n; values = Array.make n false; ts = Array.make n 0; cur = 1; fv = 0 }

let check_index a i =
  if i < 0 || i >= a.n then
    invalid_arg (Printf.sprintf "index out of bounds: %d (length %d)" i a.n)

let set a i b =
  check_index a i;
  a.values.(i) <- b;
  a.ts.(i) <- a.cur

let get a i =
  check_index a i;
  if a.ts.(i) <= a.fv then false else a.values.(i)

let clear a =
  a.fv <- a.cur;
  a.cur <- a.cur + 1
