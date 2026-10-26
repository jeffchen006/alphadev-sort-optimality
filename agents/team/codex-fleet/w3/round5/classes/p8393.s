# n=5 model=out iset=I1 prefix14_class=8393
mov S0, P0
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
cmp S0, P3
cmovge P0, P3
mov S2, P2
cmovg P3, S0
mov S0, P3
cmp P3, P1
cmovl S0, P1
cmovg P3, P1
cmovle P1, P3
