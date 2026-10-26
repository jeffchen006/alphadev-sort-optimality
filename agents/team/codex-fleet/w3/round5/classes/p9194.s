# n=5 model=out iset=I1 prefix14_class=9194
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
mov S2, P1
cmp P1, P2
cmovge P1, P2
cmovle S2, P2
cmovl P2, P1
cmp P2, P0
cmovge P2, P0
cmovg P0, P1
cmovle P1, P0
mov P2, S2
