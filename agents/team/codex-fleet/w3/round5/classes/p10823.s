# n=5 model=out iset=I1 prefix14_class=10823
mov S1, P0
cmp P2, S1
cmovg P0, P2
cmovl S1, P2
cmovg P2, S1
mov S0, P0
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov P0, P3
