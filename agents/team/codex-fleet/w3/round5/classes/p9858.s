# n=5 model=out iset=I1 prefix14_class=9858
cmp P2, P1
mov S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P3, P0
mov S0, P1
cmovge P2, P0
cmovge P0, P3
cmovge P3, P2
cmp P0, S0
cmovle P1, P0
cmovl P0, S0
mov P0, P1
cmp P3, S2
