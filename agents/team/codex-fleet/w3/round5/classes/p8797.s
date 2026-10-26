# n=5 model=out iset=I1 prefix14_class=8797
mov S1, P3
mov S0, P0
cmp P3, P2
cmovle P3, P2
cmovg S1, P2
cmp S0, P1
cmovl P0, P1
cmovle P1, S0
mov S0, P1
cmp P3, P0
cmovg P2, P3
cmovge P3, P0
cmovg P0, P2
cmp S0, S1
