# n=5 model=out iset=I1 prefix14_class=13574
mov S1, P1
cmp P2, S1
cmovle P1, P2
cmovg S1, P2
mov S0, P3
cmp S0, P0
cmovle P3, P0
mov S2, P1
cmovg S0, P0
cmp S2, S0
cmovg P1, S0
cmovle S2, S0
cmp S1, P3
cmovle S0, S1
