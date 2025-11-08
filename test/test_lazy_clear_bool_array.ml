open Bool_vector

let test name f =
  try
    f ();
    Printf.printf "✓ %s\n" name;
    true
  with e ->
    Printf.printf "✗ %s: %s\n" name (Printexc.to_string e);
    false

let run_tests () =
  let module A = Lazy_clear_bool_array in
  let tests =
    [
      ( "create array",
        fun () ->
          let a = A.create 10 in
          assert (A.length a = 10) );
      ( "negative length raises exception",
        fun () ->
          try
            let _ = A.create (-1) in
            assert false
          with Invalid_argument _ -> () );
      ( "initial values are false",
        fun () ->
          let a = A.create 5 in
          for i = 0 to 4 do
            assert (not (A.get a i))
          done );
      ( "set and get true",
        fun () ->
          let a = A.create 5 in
          A.set a 2 true;
          assert (A.get a 2) );
      ( "set and get false",
        fun () ->
          let a = A.create 5 in
          A.set a 2 true;
          A.set a 2 false;
          assert (not (A.get a 2)) );
      ( "out of bounds get",
        fun () ->
          let a = A.create 5 in
          try
            let _ = A.get a 5 in
            assert false
          with Invalid_argument _ -> () );
      ( "negative index get",
        fun () ->
          let a = A.create 5 in
          try
            let _ = A.get a (-1) in
            assert false
          with Invalid_argument _ -> () );
      ( "out of bounds set",
        fun () ->
          let a = A.create 5 in
          try
            A.set a 5 true;
            assert false
          with Invalid_argument _ -> () );
      ( "negative index set",
        fun () ->
          let a = A.create 5 in
          try
            A.set a (-1) true;
            assert false
          with Invalid_argument _ -> () );
      ( "clear makes all values false",
        fun () ->
          let a = A.create 5 in
          A.set a 0 true;
          A.set a 2 true;
          A.set a 4 true;
          A.clear a;
          for i = 0 to 4 do
            assert (not (A.get a i))
          done );
      ( "set after clear",
        fun () ->
          let a = A.create 5 in
          A.set a 2 true;
          A.clear a;
          A.set a 3 true;
          assert (not (A.get a 2));
          assert (A.get a 3) );
      ( "multiple clears",
        fun () ->
          let a = A.create 5 in
          A.set a 1 true;
          A.clear a;
          A.set a 2 true;
          A.clear a;
          A.set a 3 true;
          assert (not (A.get a 1));
          assert (not (A.get a 2));
          assert (A.get a 3) );
      ( "clear is idempotent",
        fun () ->
          let a = A.create 5 in
          A.set a 1 true;
          A.clear a;
          A.clear a;
          assert (not (A.get a 1)) );
      ( "mixed operations",
        fun () ->
          let a = A.create 10 in
          A.set a 0 true;
          A.set a 5 true;
          A.set a 9 false;
          A.clear a;
          A.set a 3 true;
          A.set a 7 false;
          assert (not (A.get a 0));
          assert (not (A.get a 5));
          assert (A.get a 3);
          assert (not (A.get a 7)) );
      ( "zero length array",
        fun () ->
          let a = A.create 0 in
          assert (A.length a = 0);
          A.clear a );
      ( "stress test with many clears",
        fun () ->
          let a = A.create 100 in
          for _ = 0 to 999 do
            A.set a 50 true;
            A.clear a
          done;
          assert (not (A.get a 50)) );
    ]
  in

  let results = List.map (fun (name, f) -> test name f) tests in

  let total = List.length results in
  let passed = List.filter (fun x -> x) results |> List.length in
  Printf.printf "\n%d/%d tests passed\n" passed total;

  if passed = total then exit 0 else exit 1

let () = run_tests ()
