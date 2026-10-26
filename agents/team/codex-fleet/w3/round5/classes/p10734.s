# n=5 model=out iset=I1 prefix14_class=10734
mov S2, P3
cmp P3, P1
cmovle P3, P1
cmovge S2, P1
cmp P2, P0
mov S0, P3
mov P1, S2
cmovle S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P2, P3
cmovge P3, P2
cmovge P2, S0
mov P3, P2
