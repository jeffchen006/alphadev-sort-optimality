# n=5 model=out iset=I1 prefix14_class=2008
mov S1, P1
cmp P0, S1
cmovg P1, P0
cmovg P0, S1
mov S1, P2
cmp P2, P3
cmovge P2, P3
cmovle S1, P3
cmovge P3, S1
cmp P1, S1
cmovl S1, P1
cmovge P3, P1
mov P1, S1
cmp P0, P2
