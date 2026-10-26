# n=5 model=out iset=I1 prefix14_class=4673
mov S2, P1
mov S1, P0
cmp P3, S1
cmovge P0, P3
cmovge P3, S1
cmp P2, S2
cmovle S2, P2
cmovl P2, P1
mov S1, S2
cmp P2, P0
cmovge P1, P0
cmovg P0, P2
cmovg P2, P1
cmp S2, P3
