# n=5 model=out iset=I1 prefix14_class=4255
mov S1, P0
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
mov P2, P1
cmp P3, P2
cmovg P2, P3
cmovg P3, P1
cmp P3, S1
mov P1, S1
cmovl S1, P3
cmovge P1, P3
mov S1, P1
cmp P0, P2
