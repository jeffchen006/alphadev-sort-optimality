# n=5 model=out iset=I1 prefix14_class=7879
mov S2, P1
cmp P1, P0
cmovg S2, P0
cmovg P0, P1
mov P1, P3
cmp P1, P2
cmovg P1, P2
cmovle P3, P2
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
cmovg P1, S0
cmp P0, P3
cmovle P2, P0
