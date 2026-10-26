# n=5 model=out iset=I1 prefix14_class=7497
cmp P0, P3
mov S0, P0
mov S1, P2
cmovg P0, P3
cmovge P3, S0
cmp P2, P1
cmovge S1, P1
cmovle P2, P1
mov S0, S1
cmp P0, S0
cmovle S0, P0
cmovg S1, P0
cmp P3, P2
cmovl P0, S1
