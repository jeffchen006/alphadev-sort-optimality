# n=5 model=out iset=I1 prefix14_class=12562
cmp P1, P0
mov S2, P0
cmovg P0, P1
cmovge P1, S2
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovge S0, P2
cmp S0, P1
cmovle S1, P1
mov S2, P3
cmovle P1, S0
cmovl S0, S1
mov P1, S0
