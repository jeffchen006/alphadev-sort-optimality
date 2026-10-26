# n=5 model=out iset=I1 prefix14_class=9834
cmp P1, P0
mov S1, P0
cmovge P0, P1
cmovl S1, P1
cmp P3, P2
mov P1, P2
cmovg P2, P3
cmovge P3, P1
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
mov P1, P2
cmp S1, P3
