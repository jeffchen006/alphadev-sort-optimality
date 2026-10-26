# n=5 model=out iset=I1 prefix14_class=2435
mov S0, P0
cmp P3, S0
cmovge P0, P3
cmovl S0, P3
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
cmovl P1, S2
mov P3, P2
mov S1, S0
cmp P0, P2
cmovg P3, P0
cmovge P0, P2
cmp P1, S1
