# n=5 model=out iset=I1 prefix14_class=2847
mov S2, P0
cmp P2, P1
mov S1, P2
cmovge S1, P1
cmovl P2, P1
cmp S2, P3
cmovg S2, P3
cmovg P3, P0
cmp P3, P2
mov P1, P2
cmovle P1, P3
mov S0, S1
cmovl P3, P2
mov P2, P1
