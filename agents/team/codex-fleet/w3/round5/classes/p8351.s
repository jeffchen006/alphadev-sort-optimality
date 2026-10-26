# n=5 model=out iset=I1 prefix14_class=8351
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov S2, P1
cmovle P0, S0
cmp P2, P1
cmovge P1, P2
cmovge P2, S2
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovl S1, P3
mov P3, P1
mov P2, S1
