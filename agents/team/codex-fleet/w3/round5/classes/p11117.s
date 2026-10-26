# n=5 model=out iset=I1 prefix14_class=11117
mov S2, P3
mov S0, P0
cmp P2, S2
cmovge P3, P2
cmovl S2, P2
cmp P0, P1
cmovle P0, P1
cmovl P1, S0
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
mov P2, P3
cmp S2, P1
