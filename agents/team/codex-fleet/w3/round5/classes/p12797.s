# n=5 model=out iset=I1 prefix14_class=12797
cmp P3, P2
mov S1, P2
mov S0, P1
cmovle S1, P3
cmovg P2, P3
cmp P1, P0
cmovg P1, P0
cmovg P0, S0
cmp S1, P1
cmovg S2, S1
cmovg S1, P1
cmovg P1, S2
mov S1, P2
cmp S1, P0
