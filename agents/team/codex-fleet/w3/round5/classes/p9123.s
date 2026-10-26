# n=5 model=out iset=I1 prefix14_class=9123
mov S0, P2
cmp P2, P0
cmovle P2, P0
cmovg S0, P0
cmp P3, P1
cmovge S1, P3
mov P0, S0
cmovge P3, P1
cmovge P1, S1
cmp P3, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
cmovle S1, P1
