# n=5 model=out iset=I1 prefix14_class=7059
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovge P3, P2
cmp P0, P1
cmovg P2, P0
cmovg P0, P1
cmovg P1, P2
cmp P0, P3
mov S2, P0
cmovle P0, P3
mov S0, S1
cmovl P3, S2
cmp S1, P1
