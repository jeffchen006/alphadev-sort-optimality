# n=5 model=out iset=I1 prefix14_class=8715
mov S2, P2
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovg P0, S0
cmp S2, P3
cmovge S2, P3
cmovl P2, P3
mov S1, P1
cmp P2, S1
cmovle P1, P2
cmovg S1, P2
mov P3, P1
mov P2, P0
