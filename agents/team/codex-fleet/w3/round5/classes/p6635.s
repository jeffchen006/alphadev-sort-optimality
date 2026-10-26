# n=5 model=out iset=I1 prefix14_class=6635
mov S0, P2
mov S1, P3
cmp P0, P2
cmovl P2, P0
cmovg S0, P0
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmp S0, S1
mov P3, P1
cmovge P0, S0
cmovg S0, S1
cmovg S1, P0
cmp P2, P3
