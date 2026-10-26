# n=5 model=out iset=I1 prefix14_class=13447
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P1, S2
cmovl S0, P1
