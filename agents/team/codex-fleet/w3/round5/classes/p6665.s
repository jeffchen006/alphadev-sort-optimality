# n=5 model=out iset=I1 prefix14_class=6665
mov S2, P2
cmp P3, P2
cmovl P2, P3
cmovl P3, S2
mov S2, P0
cmp P1, P0
cmovge P0, P1
cmovge P1, S2
mov S2, P0
cmp P3, P0
cmovg P0, P3
cmovle S2, P3
mov P0, S2
mov P3, P2
