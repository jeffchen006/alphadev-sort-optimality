# n=5 model=out iset=I1 prefix14_class=5490
cmp P3, P1
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
mov S0, P0
cmovle S0, P2
cmovge P0, P2
mov S2, P0
cmp P0, P1
cmovl S2, P1
cmovle P1, P0
mov P1, P3
cmp P1, S0
