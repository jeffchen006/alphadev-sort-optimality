# n=5 model=out iset=I1 prefix14_class=13673
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
mov S0, P1
cmovl P3, S1
cmp P2, S0
cmovg P1, P2
mov S2, P1
cmovge P2, S0
cmp P1, P3
cmovle S2, P3
cmovge P1, P3
mov P3, P2
cmp P3, P0
