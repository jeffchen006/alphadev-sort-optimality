# n=5 model=out iset=I1 prefix14_class=5813
mov S0, P3
cmp S0, P1
cmovle S0, P1
mov S1, P0
cmovge P3, P1
cmp S1, P2
cmovl S1, P2
cmovle P2, P0
mov P1, P2
cmp P1, P3
cmovg P2, P3
cmovle P1, P3
cmp S1, S0
cmovl P0, S0
