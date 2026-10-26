# n=5 model=out iset=I1 prefix14_class=13660
mov S0, P0
cmp P0, P1
mov S1, P2
cmovge P0, P1
cmovle S0, P1
cmp S1, P3
cmovl P2, P3
cmovle P3, S1
cmp S0, P2
cmovge P1, S0
mov S2, P0
cmovg S0, P2
cmovg P2, P1
cmp P3, P0
