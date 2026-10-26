# n=5 model=out iset=I1 prefix14_class=9737
mov S0, P2
mov S1, P1
cmp S0, P3
cmovg P2, P3
cmovge P3, S0
cmp P0, S1
cmovle P1, P0
cmovle P0, S1
mov S2, P1
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
mov P0, P3
