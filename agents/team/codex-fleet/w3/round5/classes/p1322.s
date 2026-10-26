# n=5 model=out iset=I1 prefix14_class=1322
cmp P1, P2
cmovle S0, P2
cmovg S0, P1
mov S2, P3
cmovle P2, P1
cmovl P1, S0
cmp P3, P0
cmovg P3, P0
cmovge P0, S2
cmp P0, S0
cmovl S0, P0
cmovge P1, P0
cmovge P0, S0
cmp P3, P2
