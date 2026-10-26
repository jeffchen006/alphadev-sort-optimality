# n=5 model=out iset=I1 prefix14_class=8010
mov S1, P0
cmp P1, P0
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
mov S2, P0
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp P2, P1
mov S0, P1
cmovge P1, P2
cmovl S0, P2
cmovl P2, P1
