# n=5 model=out iset=I1 prefix14_class=3037
mov S2, P2
cmp P3, P2
cmovle P2, P3
cmovle P3, S2
mov S1, P1
cmp P0, S1
cmovle S1, P0
cmovge P1, P0
cmp P2, S1
mov P0, P2
cmovle P2, S1
cmovl S1, P0
mov S1, P1
mov S0, P2
