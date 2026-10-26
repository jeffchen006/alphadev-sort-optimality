# n=5 model=out iset=I1 prefix14_class=12477
cmp P0, P1
mov S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P3, P2
cmovg S1, P2
cmovg P2, P3
cmovg P3, S1
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovg S0, P3
mov P0, S0
cmp P2, P1
