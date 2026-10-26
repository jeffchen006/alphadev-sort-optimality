# n=5 model=out iset=I1 prefix14_class=60
mov S1, P2
cmp P1, S1
mov S2, P3
cmovle S1, P1
cmovl P1, P2
cmp P0, S2
cmovle S2, P0
mov P2, S1
cmovg P3, P0
cmp P2, S2
cmovge P2, S2
cmovle S1, S2
cmovge S2, S1
mov S0, P1
