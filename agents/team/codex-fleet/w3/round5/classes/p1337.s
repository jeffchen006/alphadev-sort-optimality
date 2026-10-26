# n=5 model=out iset=I1 prefix14_class=1337
cmp P0, P1
mov S1, P0
cmovl S1, P1
cmovl P1, P0
cmp P3, P2
mov P0, P3
cmovge P0, P2
mov S2, S1
cmovge P2, P3
cmp P2, S2
cmovle S2, P2
cmovg S1, P2
cmp P1, P0
mov S1, P0
