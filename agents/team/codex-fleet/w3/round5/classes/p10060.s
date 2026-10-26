# n=5 model=out iset=I1 prefix14_class=10060
mov S2, P0
cmp P0, P3
cmovle P0, P3
mov S1, P1
cmovl P3, S2
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
cmp P0, P2
cmovge S1, P2
cmovg P2, P0
cmovge P0, S1
cmp P1, P3
cmovle S1, P3
