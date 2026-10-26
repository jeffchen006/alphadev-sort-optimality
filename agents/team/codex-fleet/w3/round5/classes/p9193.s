# n=5 model=out iset=I1 prefix14_class=9193
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovg P0, S1
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
cmovl P1, P2
cmp P2, P0
cmovge P1, P0
cmovg P0, P2
cmovle P2, P0
mov P1, P3
