# n=5 model=out iset=I1 prefix14_class=10834
mov S0, P2
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmovle S2, P3
cmp P0, S0
cmovge S0, P0
cmovg P0, P2
cmp S0, S2
cmovge P2, S0
cmovg S0, S2
cmovge S2, P2
cmp P1, P0
cmovl P3, P0
